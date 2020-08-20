using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using ArcSoftware.ScavengerHunt.Data.DbModels;
using Microsoft.EntityFrameworkCore;

namespace ArcSoftware.ScavengerHunt.Data.Repo
{
    public class Repository : IRepository
    {
        private readonly ScavengerHuntContext _context;

        public Repository(ScavengerHuntContext context)
        {
            _context = context;
        }

        public T GetItem<T>(Expression<Func<T, bool>> predicate, params Expression<Func<T, object>>[] include)
            where T : class
        {
            IQueryable<T> query = _context.Set<T>();
            query = include.Aggregate(query, (current, expression) => current.Include(expression));
            return query?.FirstOrDefault(predicate);
        }

        public IQueryable<T> GetItems<T>(Expression<Func<T, bool>> predicate,
            params Expression<Func<T, object>>[] include)
            where T : class
        {
            IQueryable<T> query = _context.Set<T>();
            query = include.Aggregate(query, (current, expression) => current.Include(expression));
            return query.Where(predicate);
        }

        public void Create<T>(T entity) where T : class
        {
            _context.Add(entity);
            _context.SaveChanges();
        }

        public void CreateMultiple<T>(IEnumerable<T> entities) where T : class
        {
            _context.ChangeTracker.AutoDetectChangesEnabled = false;

            _context.AddRange(entities);
            _context.SaveChanges();
        }

        public void Update<T>(T dbo) where T : class
        {
            _context.SaveChanges();
        }

        public void UpdateMultiple<T>(IEnumerable<T> toUpdate, IEnumerable<T> updated) where T : class
        {
            _context.RemoveRange(toUpdate);
            _context.AddRange(updated);
            _context.SaveChanges();
        }

        public void Delete<T>(T entity) where T : class
        {
            _context.Remove(entity);
            _context.SaveChanges();
        }
    }
}